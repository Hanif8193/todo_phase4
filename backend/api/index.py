import sys
import os
import traceback
import json

# Add src to path
current_dir = os.path.dirname(os.path.abspath(__file__))
src_path = os.path.join(current_dir, '..', 'src')
sys.path.insert(0, src_path)

def handler(request, context):
    """
    Diagnostic handler that shows exactly what's failing
    """
    errors = []

    # Test 1: Basic Python
    try:
        message = "Python is working!"
    except Exception as e:
        errors.append(f"Basic Python failed: {str(e)}")

    # Test 2: Import mangum
    try:
        from mangum import Mangum
        errors.append("Mangum imported successfully")
    except Exception as e:
        errors.append(f"Mangum import failed: {str(e)}")

    # Test 3: Import main
    try:
        from main import app
        errors.append("Main app imported successfully")

        # Test 4: Wrap with Mangum
        try:
            handler_func = Mangum(app, lifespan="off")
            errors.append("Mangum wrapper created successfully")

            # Test 5: Call the handler
            try:
                return handler_func(request, context)
            except Exception as e:
                errors.append(f"Handler execution failed: {str(e)}")
                errors.append(f"Traceback: {traceback.format_exc()}")
        except Exception as e:
            errors.append(f"Mangum wrapper failed: {str(e)}")
            errors.append(f"Traceback: {traceback.format_exc()}")
    except Exception as e:
        errors.append(f"Main import failed: {str(e)}")
        errors.append(f"Traceback: {traceback.format_exc()}")

    # Return diagnostic info
    return {
        "statusCode": 500,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "message": "Diagnostic Mode",
            "python_version": sys.version,
            "sys_path": sys.path[:3],
            "errors": errors
        }, indent=2)
    }
