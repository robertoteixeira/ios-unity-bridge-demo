using UnityEngine;
using UnityEngine.InputSystem;

public class BridgeDebugTester : MonoBehaviour
{
    [SerializeField] private IOSBridgeReceiver bridgeReceiver;

    private void Update()
    {
        if (bridgeReceiver == null)
        {
            return;
        }

        Keyboard keyboard = Keyboard.current;

        if (keyboard == null)
        {
            return;
        }

        if (keyboard.cKey.wasPressedThisFrame)
        {
            bridgeReceiver.ReceiveCommand("{\"type\":\"changeColor\",\"payload\":{\"color\":\"blue\"}}");
        }

        if (keyboard.rKey.wasPressedThisFrame)
        {
            bridgeReceiver.ReceiveCommand("{\"type\":\"startRotation\",\"payload\":{\"speed\":\"1.0\"}}");
        }

        if (keyboard.sKey.wasPressedThisFrame)
        {
            bridgeReceiver.ReceiveCommand("{\"type\":\"stopRotation\",\"payload\":{}}");
        }

        if (keyboard.xKey.wasPressedThisFrame)
        {
            bridgeReceiver.ReceiveCommand("{\"type\":\"resetCube\",\"payload\":{}}");
        }

        if (keyboard.tKey.wasPressedThisFrame)
        {
            bridgeReceiver.ReceiveCommand("{\"type\":\"requestStatus\",\"payload\":{}}");
        }
    }
}