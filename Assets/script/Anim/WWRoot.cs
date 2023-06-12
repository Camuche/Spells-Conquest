using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WWRoot : MonoBehaviour
{
    bool isTrigger = false;

    [SerializeField] GameObject root;
    [SerializeField] GameObject target;
    [SerializeField] GameObject trigger;

    [SerializeField] float positionSpeed;
    [SerializeField] float scaleSpeed;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (isTrigger == true)
        {
            root.transform.position = Vector3.MoveTowards(root.transform.position, target.transform.position, 0.01f * positionSpeed);
            root.transform.localScale = Vector3.MoveTowards(root.transform.localScale, target.transform.localScale, 0.01f * scaleSpeed);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "WaterWave")
        {
            isTrigger = true;
            trigger.GetComponent<MeshRenderer>().enabled = false;
            
        }
    }
}
