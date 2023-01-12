using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FireballTriggerTorch : MonoBehaviour
{
    Renderer fireRenderer;
    public Material green;

    public int torchOnNeeded;
    int torchOnNumber = 0;

    public GameObject obstacle;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (torchOnNumber >= torchOnNeeded)
        {
            Debug.Log("DoorOpen");
            obstacle.SetActive(false);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Fireball")
        {
            fireRenderer = GetComponent<Renderer>();
            fireRenderer.material.CopyPropertiesFromMaterial(green);

            torchOnNumber += 1;
            foreach (Transform child in transform)
            {
                child.gameObject.SetActive(true);
            }
        }
    }
}
