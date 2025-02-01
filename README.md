# Send Email Flask Python API App

This is a simple Flask Python API app that is used to learn how to create resources in Azure and deploy a Flask Python API app to Azure App Service. 

It is used to send emails to a list of email addresses.



## Prerequisites

- Azure CLI - install and login to Azure CLI
    - Validate you have an azure subscription
- Python 3.12
- Windows

## Setup (Windows)

1. Clone the repository
2. Run `.\setup-venv.bat` from the devops folderto create a virtual environment and install the dependencies
3. Create `.env` file in the root of the repository with the following content:
    ``` 
    FLASK_APP=src.app:create_app()
    SMTP_SERVER=smtp.gmail.com
    SMTP_PORT=587
    SMTP_USERNAME=(gmail address)
    SMTP_PASSWORD= (gmail app password)
    TEST_TO_EMAIL= (email address to send test email to)
    ```
5. Make sure venv is activated and run app locally by running `flask run` in the root of the repository
6. Create `.\config.bat` in the devops folder using the template in `devops/config.template.bat`
7. Run `.\create-resources.bat` in the devops folder to create the Azure resources
8. Run `.\set-email-config.bat` in the devops folder to set the email configuration
9. Run `.\deploy-webapp.bat` in the devops folder to deploy the app to Azure App Service
10. Login to Azure Portal and validate the resources were created and the app is running


## Endpoints
- Main: /
- Send Test Email: /email/send-test
