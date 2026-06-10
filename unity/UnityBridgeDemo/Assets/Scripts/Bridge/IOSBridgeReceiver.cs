using UnityEngine;

public class IOSBridgeReceiver : MonoBehaviour
{
    [SerializeField] private CubeController cubeController;
    [SerializeField] private IOSBridgeSender bridgeSender;

    public void ReceiveCommand(string message)
    {
        Debug.Log($"[IOSBridgeReceiver] Received command: {message}");

        if (message.Contains("\"changeColor\""))
        {
            string color = ExtractValue(message, "color", "blue");
            cubeController.ChangeColor(color);
            bridgeSender.SendEvent("statusResponse", $"{{\"currentColor\":\"{color}\"}}");
            return;
        }

        if (message.Contains("\"startRotation\""))
        {
            cubeController.StartRotation();
            bridgeSender.SendEvent("rotationStarted", "{\"speed\":\"1.0\"}");
            return;
        }

        if (message.Contains("\"stopRotation\""))
        {
            cubeController.StopRotation();
            bridgeSender.SendEvent("rotationStopped");
            return;
        }

        if (message.Contains("\"resetCube\""))
        {
            cubeController.ResetCube();
            bridgeSender.SendEvent("statusResponse", "{\"cube\":\"reset\"}");
            return;
        }

        if (message.Contains("\"requestStatus\""))
        {
            string status = cubeController.GetStatus();
            bridgeSender.SendEvent("statusResponse", $"{{\"status\":\"{status}\"}}");
            return;
        }

        bridgeSender.SendEvent("error", "{\"message\":\"Unknown command\"}");
    }

    private string ExtractValue(string message, string key, string fallback)
    {
        string pattern = $"\"{key}\":\"";
        int startIndex = message.IndexOf(pattern);

        if (startIndex < 0)
        {
            return fallback;
        }

        startIndex += pattern.Length;
        int endIndex = message.IndexOf("\"", startIndex);

        if (endIndex < 0)
        {
            return fallback;
        }

        return message.Substring(startIndex, endIndex - startIndex);
    }
}