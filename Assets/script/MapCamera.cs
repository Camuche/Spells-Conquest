using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class MapCamera : MonoBehaviour
{
    [SerializeField] float positionY;
    GameObject player;
    public GameObject mapMarker;
    [SerializeField] float zoomSpeed, zoomMax, zoomMin, mapMarkerSize;

    [SerializeField] private InputActionReference l2, r2;
    

    // Start is called before the first frame update
    void Start()
    {
        player = GameObject.Find("Player").gameObject;
        GetComponent<Camera>().enabled = false;
        
    }

    // Update is called once per frame
    void Update()
    {   
        positionY = Mathf.Clamp(positionY, zoomMax, zoomMin);

        transform.position = new Vector3(player.transform.position.x , positionY , player.transform.position.z);
        transform.rotation = Quaternion.Euler(90,0,0);

        mapMarker.transform.position = transform.position - new Vector3(0,mapMarkerSize,0);
        mapMarker.transform.rotation = player.transform.rotation * Quaternion.Euler(90,0,0);
        //mapMarker.transform.rotation *= Quaternion.Euler(90,0,0);

        if (l2.action.ReadValue<float>() >0)
        {
            positionY += l2.action.ReadValue<float>() * zoomSpeed;   
        }
        else if (r2.action.ReadValue<float>() >0)
        {
            positionY -= r2.action.ReadValue<float>() * zoomSpeed;
        }
    }
}
