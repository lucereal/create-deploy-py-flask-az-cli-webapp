from flask import Flask
from .controllers.main_controller import main
from .controllers.email_controller import email

def create_app():
    app = Flask(__name__)
    
    # Register blueprints
    app.register_blueprint(main)
    app.register_blueprint(email)
    
    return app

if __name__ == '__main__':
    app = create_app()
    app.run()
