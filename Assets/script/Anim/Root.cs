using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Root : MonoBehaviour
{
    [SerializeField] Renderer root;

    private float startFloat = 1;
    [SerializeField] float speed;

    private bool boolEnable = false;

    float timer = 0;


    // Start is called before the first frame update
    void Start()
    {
        startFloat = 0;
    }

    // Update is called once per frame
    void Update()
    {


        if (boolEnable == true)
        {
            if (startFloat < 1)
            {
                startFloat += speed * Time.deltaTime;

            }
            else startFloat = 1;

            timer += Time.deltaTime;

            if (timer>= 3f)
            {
                timer = 0f;
                boolEnable = false;
            }
            
        }

        if (boolEnable == false)
        {
            if (startFloat > 0 )
            {
                startFloat -= speed * Time.deltaTime;

            }
            else startFloat = 0;

        }

        root.material.SetFloat("_Grow", startFloat);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Fireball")
        {
            boolEnable = true;
        }
    }
}
