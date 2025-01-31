from flask import Blueprint, jsonify


main = Blueprint('main', __name__, url_prefix='/')

@main.route('/', methods=['GET'])
def index():
    return jsonify({
        "success": True,
        "message": "Welcome to the Flask API"
    }) 
