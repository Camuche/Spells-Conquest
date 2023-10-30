using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerRaycast : MonoBehaviour
{
    public float maxDistance = 100;

    private RaycastHit hit;
    private Raycastable previousRaycastable;
    private Raycastable raycastable;

    public static bool waitForNextFrame = false;

    private Vector2 prevMousePos;
    private Vector3 cursorInput;

    public Transform refCursor;
    private Camera refCamera;
    public float cursorSpeed;
    private Vector3 cursorScreenPos;

    public bool stopWhenPaused = true;

    [SerializeField] private InputActionReference mousePos,interact;

	private void Start()
	{
        refCamera = GetComponent<Camera>();

    }

	// Update is called once per frame
	void Update()
    {
        if(waitForNextFrame || (Time.timeScale == 0 && stopWhenPaused))
		{
            return;
		}

        /*if(mousePos.action.ReadValue<Vector2>() != prevMousePos)
		{
            refCursor.position = refCamera.ScreenToWorldPoint(new Vector3(mousePos.action.ReadValue<Vector2>().x, mousePos.action.ReadValue<Vector2>().y, 0.2f));
        }

        prevMousePos = mousePos.action.ReadValue<Vector2>();

        //cursorInput = InputListener.instance.cursorInput;

        if (cursorInput.magnitude > 0)
		{
            refCursor.position += refCamera.transform.right * cursorInput.x * cursorSpeed + refCamera.transform.up * cursorInput.y * cursorSpeed;

            cursorScreenPos = refCamera.WorldToScreenPoint(refCursor.position);

            if (cursorScreenPos.x < 0)
			{
                refCursor.position = refCamera.ScreenToWorldPoint(new Vector3(0, cursorScreenPos.y, 0.2f));
            }

            if (cursorScreenPos.y < 0)
            {
                refCursor.position = refCamera.ScreenToWorldPoint(new Vector3(cursorScreenPos.x, 0, 0.2f));
            }

            if (cursorScreenPos.x > Screen.width)
            {
                refCursor.position = refCamera.ScreenToWorldPoint(new Vector3(Screen.width, cursorScreenPos.y, 0.2f));
            }

            if (cursorScreenPos.y > Screen.height)
            {
                refCursor.position = refCamera.ScreenToWorldPoint(new Vector3(cursorScreenPos.x, Screen.height, 0.2f));
            }
        }

        cursorScreenPos = refCamera.WorldToScreenPoint(refCursor.position);*/
        //Physics.Raycast(Camera.main.ScreenPointToRay(new Vector3(Input.mousePosition.x, Input.mousePosition.y, maxDistance)), out hit);
        Physics.Raycast(refCamera.ScreenPointToRay(new Vector3(mousePos.action.ReadValue<Vector2>().x, mousePos.action.ReadValue<Vector2>().y, maxDistance)), out hit);

        Debug.Log(hit.collider);

        if (hit.collider != null)
        {
            raycastable = hit.collider.GetComponent<Raycastable>();

            if((hit.point - transform.position).magnitude > maxDistance)
			{
                raycastable = null;
            }
        }
        else
		{
            raycastable = null;
        }

        if(previousRaycastable != raycastable)
		{
            if (previousRaycastable != null)
            {
                previousRaycastable.PerformOnOut();
            }

            previousRaycastable = raycastable;

            if (raycastable != null)
            {
                raycastable.PerformOnOver();
            }
        }

        if (raycastable != null)
        {
            if (interact.action.IsPressed())
            {
                raycastable.PerformOnInteract();
            }
        }

        
    }

	private void LateUpdate()
	{
		if(waitForNextFrame)
		{
            waitForNextFrame = false;
        }
	}
}
