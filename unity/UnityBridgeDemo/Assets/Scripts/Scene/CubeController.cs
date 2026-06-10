using UnityEngine;
using UnityEngine.InputSystem;

public class CubeController : MonoBehaviour
{
    [SerializeField] private float rotationSpeed = 90f;
    [SerializeField] private IOSBridgeSender bridgeSender;
    [SerializeField] private Camera sceneCamera;

    private Renderer cubeRenderer;
    private bool isRotating;

    private void Awake()
    {
        cubeRenderer = GetComponent<Renderer>();

        if (sceneCamera == null)
        {
            sceneCamera = Camera.main;
        }
    }

    private void Update()
    {
        HandleRotation();
        HandlePointerInput();
    }

    private void HandleRotation()
    {
        if (!isRotating)
        {
            return;
        }

        transform.Rotate(Vector3.up, rotationSpeed * Time.deltaTime);
    }

    private void HandlePointerInput()
    {
        if (sceneCamera == null)
        {
            return;
        }

        if (Mouse.current != null && Mouse.current.leftButton.wasPressedThisFrame)
        {
            Vector2 mousePosition = Mouse.current.position.ReadValue();
            CheckTap(mousePosition);
        }

        if (Touchscreen.current != null && Touchscreen.current.primaryTouch.press.wasPressedThisFrame)
        {
            Vector2 touchPosition = Touchscreen.current.primaryTouch.position.ReadValue();
            CheckTap(touchPosition);
        }
    }

    private void CheckTap(Vector2 screenPosition)
    {
        Ray ray = sceneCamera.ScreenPointToRay(screenPosition);

        if (!Physics.Raycast(ray, out RaycastHit hit))
        {
            return;
        }

        if (hit.collider.gameObject != gameObject)
        {
            return;
        }

        bridgeSender?.SendEvent(
            "cubeTapped",
            $"{{\"objectName\":\"{gameObject.name}\"}}"
        );
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