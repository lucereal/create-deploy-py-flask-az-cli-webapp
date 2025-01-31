import os
from flask import Blueprint, jsonify
from src.service.email_service import EmailService
from dotenv import load_dotenv

load_dotenv()

email = Blueprint('email', __name__, url_prefix='/email')
email_service = EmailService()

@email.route('/', methods=['GET'])
def email_world():
    return jsonify({
        "success": True,
        "message": "Email API"
    })

@email.route('/send-test', methods=['GET'])
def send_test_email():
    try:
        success = email_service.send_email(
            to_email= os.getenv('TEST_TO_EMAIL'),
            subject="Test Email from Flask API",
            content="This is a test email sent from your Flask application."
        )
        
        if success:
            return jsonify({
                "success": True,
                "message": "Test email sent successfully"
            })
        else:
            return jsonify({
                "success": False,
                "message": "Failed to send email"
            }), 500
            
    except Exception as e:
        return jsonify({
            "success": False,
            "message": f"Error: {str(e)}"
        }), 500 