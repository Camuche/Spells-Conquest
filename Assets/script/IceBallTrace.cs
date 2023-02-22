using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IceBallTrace : MonoBehaviour
{

    [SerializeField] float durationTime;
    [SerializeField] float transitionDelay;
    float timer = 0;


    void OnValidate()
    {
        if (transitionDelay == 0)
            transitionDelay = 0.001f;
    }


    // Start is called before the first frame update
    void Start()
    {


        //detect water
        int water_mask = LayerMask.GetMask("Water");

        if (
            Physics.Raycast(transform.position + Vector3.up + Vector3.left * 2, Vector3.down, 1.1f, water_mask) ||
            Physics.Raycast(transform.position + Vector3.up + Vector3.right * 2, Vector3.down, 1.1f, water_mask) ||
            Physics.Raycast(transform.position + Vector3.up + Vector3.forward * 2, Vector3.down, 1.1f, water_mask) ||
            Physics.Raycast(transform.position + Vector3.up + Vector3.back * 2, Vector3.down, 1.1f, water_mask)
            )
        {
            GetComponentInChildren<MeshCollider>().enabled = true;
        }
        else
        {
            Destroy(gameObject);
        }


        transform.localScale = Vector3.zero;
    }

    // Update is called once per frame
    void Update()
    {
        timer += Time.deltaTime;

        if (timer < durationTime)
        {
            if (transform.localScale.x <= 1)
            {
                transform.localScale += Vector3.one * Time.deltaTime / transitionDelay;
            }
        }
        else
        {

            transform.localScale -= Vector3.one * Time.deltaTime / transitionDelay;

            if (transform.localScale.x <= 0)
            {
                Destroy(gameObject);
            }
        }
    }

    
}
