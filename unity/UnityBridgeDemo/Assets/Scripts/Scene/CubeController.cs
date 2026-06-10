using UnityEngine;

public class CubeController : MonoBehaviour
{
    [SerializeField] private float rotationSpeed = 90f;

    private Renderer cubeRenderer;
    private bool isRotating;

    private void Awake()
    {
        cubeRenderer = GetComponent<Renderer>();
    }

    private void Update()
    {
        if (!isRotating)
        {
            return;
        }

        transform.Rotate(Vector3.up, rotationSpeed * Time.deltaTime);
    }

    public void ChangeColor(string colorName)
    {
        if (cubeRenderer == null)
        {
            return;
        }

        cubeRenderer.material.color = ColorFromName(colorName);
    }

    public void StartRotation()
    {
        isRotating = true;
    }

    public void StopRotation()
    {
        isRotating = false;
    }

    public void ResetCube()
    {
        isRotating = false;
        transform.position = Vector3.zero;
        transform.rotation = Quaternion.identity;
        ChangeColor("white");
    }

    public string GetStatus()
    {
        return $"isRotating={isRotating};position={transform.position};rotation={transform.rotation.eulerAngles}";
    }

    private Color ColorFromName(string colorName)
    {
        switch (colorName.ToLowerInvariant())
        {
            case "red":
                return Color.red;
            case "green":
                return Color.green;
            case "blue":
                return Color.blue;
            case "yellow":
                return Color.yellow;
            case "black":
                return Color.black;
            case "white":
                return Color.white;
            default:
                return Color.gray;    
        }
    }
}
