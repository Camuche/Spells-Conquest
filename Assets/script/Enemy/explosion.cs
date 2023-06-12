using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class explosion : MonoBehaviour
{

    [HideInInspector] public float scale;
    [SerializeField] GameObject mesh;
    [SerializeField] float expendTime;

    SphereCollider sphereCollider;

    float timer=1.5f;

    Vector3 rotation;
    Vector3 rotationEvo;



    // Start is called before the first frame update
    void Start()
    {
        mesh.transform.localScale = Vector3.zero;
        sphereCollider = GetComponent<SphereCollider>();
        transform.localScale *= scale;
        rotation = new Vector3((float)Random.Range(-10, 10) / 10f, (float)Random.Range(-10, 10) / 10f, (float)Random.Range(-10, 10) / 10f);
        rotationEvo = new Vector3((float)Random.Range(-10, 10) / 100f, (float)Random.Range(-10, 10) / 100f, (float)Random.Range(-10, 10) / 100f);
        //sphereCollider.radius = scale;
    }

    // Update is called once per frame
    void Update()
    {
        mesh.transform.Rotate(rotation*Time.deltaTime*100);
        rotation += rotationEvo*Time.deltaTime*10;

        if (mesh.transform.localScale.x < 1)
        {
            mesh.transform.localScale += (Vector3.one) / expendTime*Time.deltaTime;
            sphereCollider.radius -= (.5f) / expendTime * Time.deltaTime;

        }
        else
        {
            sphereCollider.enabled = false;
            mesh.transform.localScale += Vector3.one * 0.05f * Time.deltaTime;
            timer -= Time.deltaTime;
        }


        if (timer <= 0)
        {
            Destroy(gameObject);
        }
    }
}
