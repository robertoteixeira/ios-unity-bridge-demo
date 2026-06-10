using System;
using System.Collections.Generic;

[Serializable]
public class UnityCommand
{
    public string type;
    public Dictionary<string, string> payload;
}