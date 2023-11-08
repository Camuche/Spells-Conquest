using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class sliderSensitivity : MonoBehaviour
{
    bool isDragging = false;
    public Camera cameraUI;
    [SerializeField] InputActionReference mousePos;

    [SerializeField] float minX = 958, maxX=962, stepX = 0.25f;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(isDragging)
        {
            RaycastHit hit ;
            if(Physics.Raycast(cameraUI.ScreenPointToRay(new Vector3 (mousePos.action.ReadValue<Vector2>().x, mousePos.action.ReadValue<Vector2>().y, 100)) , out hit))
            {
                transform.position = new Vector3(Mathf.Clamp(hit.point.x, minX, maxX), transform.position.y , transform.position.z);
                //Debug.Log(transform.position.x);
                
            }
        }
    }

    void OnMouseDown()
    {
        //Debug.Log("down");
        isDragging = true;
    }

    void OnMouseUp()
    {
        isDragging = false;
        PlayerController.instance.SetMouseSensitivity((transform.position.x - minX) / (maxX - minX)); 
    }

    public void MoveRight()
    {
        transform.position = new Vector3(Mathf.Clamp(transform.position.x + stepX, minX, maxX), transform.position.y , transform.position.z);
        PlayerController.instance.SetMouseSensitivity((transform.position.x - minX) / (maxX - minX));
    }

    public void MoveLeft()
    {
        transform.position = new Vector3(Mathf.Clamp(transform.position.x - stepX, minX, maxX), transform.position.y , transform.position.z);
        PlayerController.instance.SetMouseSensitivity((transform.position.x - minX) / (maxX - minX));
    }
}
