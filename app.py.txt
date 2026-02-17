from flask import Flask, render_template, request, jsonify
import json
from datetime import datetime

app = Flask(__name__)

# Home route
@app.route("/")
def home():
    return render_template("index.html")

# Order API
@app.route("/order", methods=["POST"])
def order():
    data = request.json
    order_data = {
        "itemName": data.get("itemName"),
        "price": data.get("price"),
        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    }

    # Save to file
    with open("orders.json", "a") as f:
        f.write(json.dumps(order_data) + "\n")

    return jsonify({"message": "Order saved successfully"}), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
