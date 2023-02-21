using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Wave : MonoBehaviour
{

    [SerializeField] float duration;
    [SerializeField] float speed;

    Rigidbody rb;

    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        transform.localScale -= Vector3.up * 1 / duration * Time.deltaTime;

        if (transform.localScale.y <= 0)
        {
            Destroy(gameObject);
        }

        rb.velocity = transform.right * speed;
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.gameObject.layer == LayerMask.NameToLayer("enemi"))
        {
            other.transform.position+= transform.right * speed * Time.deltaTime;
        }
    }
}
