import sys
import os

# Add src to path
current_dir = os.path.dirname(os.path.abspath(__file__))
src_path = os.path.join(current_dir, '..', 'src')
sys.path.insert(0, src_path)

try:
    # Import FastAPI app
    from main import app

    # Wrap FastAPI with Mangum for serverless deployment
    from mangum import Mangum

    handler = Mangum(app, lifespan="off")

except Exception as e:
    # If import fails, create a simple error handler
    print(f"Error importing app: {e}")

    def handler(event, context):
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": f'{{"error": "Import failed", "details": "{str(e)}"}}'
        }
