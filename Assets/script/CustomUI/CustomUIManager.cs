using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class CustomUIManager : MonoBehaviour
{
    public static CustomUIManager instance;

    public CustomUIElement currentSelected;

    public float horizontalInput;
    public float verticalInput;
    private bool confirmInputDown;
    private bool cancelInputDown;

    public float inputTimer;
    public float inputTime = 0.5f;

    [SerializeField] private InputActionReference movement, interact, cancel;

    // Start is called before the first frame update
    void Awake()
    {
        instance = this;
    }

	private void Start()
	{
        currentSelected.PerformOnSelect();
    }

	// Update is called once per frame
	void Update()
    {
        horizontalInput = movement.action.ReadValue<Vector2>().x;
        verticalInput = movement.action.ReadValue<Vector2>().y;

		if (Mathf.Abs(horizontalInput) < 0.1f) { horizontalInput = 0; }
        if (Mathf.Abs(verticalInput) < 0.1f) { verticalInput = 0; }

        confirmInputDown = interact.action.IsPressed();
        cancelInputDown = cancel.action.IsPressed();

        if(confirmInputDown)
		{
            currentSelected.PerformOnConfirm();
        }

        if (cancelInputDown)
        {
            currentSelected.PerformOnCancel();
        }

        

        inputTimer += Time.deltaTime;
        if(inputTimer >= inputTime)
		{
            inputTimer = 0;

            if (horizontalInput > Mathf.Epsilon)
            {
                //Debug.Log("right");
                currentSelected.PerformOnRight();
            }
            else if (horizontalInput < -Mathf.Epsilon)
            {
                //Debug.Log("left");
                currentSelected.PerformOnLeft();
            }
            else if (verticalInput > Mathf.Epsilon)
            {
                //Debug.Log("up");
                currentSelected.PerformOnUp();
            }
            else if (verticalInput < -Mathf.Epsilon)
            {
                //Debug.Log("down");
                currentSelected.PerformOnDown();
            }
            
        }

        if (Mathf.Abs(horizontalInput) < Mathf.Epsilon && Mathf.Abs(verticalInput) < Mathf.Epsilon)
        {
            inputTimer = inputTime;
        }
    }

    public void ChangeSelected(CustomUIElement elem)
	{
        currentSelected.PerformOnDeselect();
        currentSelected = elem;
        currentSelected.PerformOnSelect();

    }
}
