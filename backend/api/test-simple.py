"""
Simple test handler to verify Vercel Python runtime works
Visit: /api/test-simple
"""

def handler(event, context):
    """Basic Vercel handler without any dependencies"""
    return {
        'statusCode': 200,
        'headers': {'Content-Type': 'application/json'},
        'body': '{"status": "Python is working on Vercel!", "event_keys": "' + str(list(event.keys())) + '"}'
    }
