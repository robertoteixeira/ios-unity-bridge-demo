using UnityEngine;

public class IOSBridgeReceiver : MonoBehaviour
{
    [SerializeField] private CubeController cubeController;
    [SerializeField] private IOSBridgeSender bridgeSender;

    public void ReceiveCommand(string message)
    {
        Debug.Log($"[IOSBridgeReceiver] Received command: {message}");

        if (cubeController == null)
        {
            bridgeSender.SendEvent("error", "{\"message\":\"CubeController is not assigned\"}");
            return;
        }

        if (bridgeSender == null)
        {
            Debug.LogError("[IOSBridgeReceiver] IOSBridgeSender is not assigned");
            return;
        }

        UnityCommand command;

        try
        {
            command = JsonUtility.FromJson<UnityCommand>(message);
        }
        catch
        {
            bridgeSender.SendEvent("error", "{\"message\":\"Invalid command JSON\"}");
            return;
        }

        if (command == null || string.IsNullOrEmpty(command.type))
        {
            bridgeSender.SendEvent("error", "{\"message\":\"Command type is missing\"}");
            return;
        }

        HandleCommand(command);
    }

    private void HandleCommand(UnityCommand command)
    {
        switch (command.type)
        {
            case "changeColor":
                HandleChangeColor(command);
                break;

            case "startRotation":
                HandleStartRotation(command);
                break;

            case "stopRotation":
                HandleStopRotation();
                break;

            case "resetCube":
                HandleResetCube();
                break;

            case "requestStatus":
                HandleRequestStatus();
                break;

            default:
                bridgeSender.SendEvent(
                    "error",
                    $"{{\"message\":\"Unknown command: {command.type}\"}}"
                );
                break;
        }
    }

    private void HandleChangeColor(UnityCommand command)
    {
        string color = command.payload?.color;

        if (string.IsNullOrEmpty(color))
        {
            color = "blue";
        }

        cubeController.ChangeColor(color);
        bridgeSender.SendEvent(
            "statusResponse",
            $"{{\"currentColor\":\"{color}\"}}"
        );
    }

    private void HandleStartRotation(UnityCommand command)
    {
        string speed = command.payload?.speed;

        if (string.IsNullOrEmpty(speed))
        {
            speed = "1.0";
        }

        cubeController.StartRotation();
        bridgeSender.SendEvent(
            "rotationStarted",
            $"{{\"speed\":\"{speed}\"}}"
        );
    }

    private void HandleStopRotation()
    {
        cubeController.StopRotation();
        bridgeSender.SendEvent("rotationStopped");
    }

    private void HandleResetCube()
    {
        cubeController.ResetCube();
        bridgeSender.SendEvent("statusResponse", "{\"cube\":\"reset\"}");
    }

    private void HandleRequestStatus()
    {
        string status = cubeController.GetStatus();

        status = status.Replace("\"", "\\\"");

        bridgeSender.SendEvent(
            "statusResponse",
            $"{{\"status\":\"{status}\"}}"
        );
    }
}