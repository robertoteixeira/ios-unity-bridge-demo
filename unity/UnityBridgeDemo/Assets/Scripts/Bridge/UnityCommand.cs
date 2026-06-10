using System;

[Serializable]
public class UnityCommand
{
    public string type;
    public UnityCommandPayload payload;
}

[Serializable]
public class UnityCommandPayload
{
    public string color;
    public string speed;
}