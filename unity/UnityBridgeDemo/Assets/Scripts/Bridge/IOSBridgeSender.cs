using System.Runtime.InteropServices;
using UnityEngine;

public class IOSBridgeSender : MonoBehaviour
{
#if UNITY_IOS && !UNITY_EDITOR
    [DllImport("__Internal")]
    private static extern void SendMessageToIOS(string message);
#endif

    public void SendEvent(string type, string payload = "{}")
    {
        string message = $"{{\"type\":\"{type}\",\"payload\":{payload}}}";

#if UNITY_IOS && !UNITY_EDITOR
        SendMessageToIOS(message);
#else
        Debug.Log($"[IOSBridgeSender] {message}");
#endif


    }
}
