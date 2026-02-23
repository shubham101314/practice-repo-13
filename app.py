from flask import Flask, render_template, request, jsonify
import json
from datetime import datetime
import os

app = Flask(__name__)
ORDERS_FILE = "orders.json"

# Ensure orders.json exists
if not os.path.exists(ORDERS_FILE):
    with open(ORDERS_FILE, "w") as f:
        json.dump([], f)  # start with empty list

# Home route
@app.route("/")
def home():
    return render_template("index.html")

# Order API
@app.route("/order", methods=["POST"])
def order():
    data = request.json

    # Validate input
    if not data or "itemName" not in data or "price" not in data or "itemId" not in data:
        return jsonify({"error": "Invalid order data"}), 400

    # Prepare order data
    order_data = {
        "itemId": data["itemId"],          # unique item id from frontend
        "itemName": data["itemName"],
        "price": data["price"],
        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    }

    # Read existing orders safely
    try:
        with open(ORDERS_FILE, "r") as f:
            orders = json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        orders = []

    # Append new order
    orders.append(order_data)

    # Save back to file
    try:
        with open(ORDERS_FILE, "w") as f:
            json.dump(orders, f, indent=4)
    except Exception as e:
        return jsonify({"error": f"Failed to save order: {str(e)}"}), 500

    return jsonify({"message": "Order saved successfully"}), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
