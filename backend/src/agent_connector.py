from openai_agent_sdk.connectors.mcp.mcp_connector import MCPConnector

class AgentConnector:
    """
    A class to manage the connection to the MCP server.
    """
    
    def __init__(self, mcp_server_url: str):
        """
        Initializes the MCPConnector.
        
        Args:
            mcp_server_url: The URL of the MCP server.
        """
        self.mcp_server_url = mcp_server_url
        self.connector = MCPConnector(mcp_server_url)

    def get_connector(self):
        """
        Returns the MCPConnector instance.
        """
        return self.connector
