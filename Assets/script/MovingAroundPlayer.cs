using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MovingAroundPlayer : MonoBehaviour
{

    GameObject player;
    Vector3 newDir;
    [SerializeField] float _timer;
    float timer=0;

    [SerializeField] public float speed;


    // Start is called before the first frame update
    void Start()
    {
        player = GameObject.Find("Player");
    }

    // Update is called once per frame
    void Update()
    {
        timer+=Time.deltaTime;

        if (player!=null && timer > _timer)
        {
            SetNewDir(0);

            timer = 0;
        }

        transform.position += newDir * speed * Time.deltaTime;
        Debug.DrawRay(transform.position + Vector3.down * 0.95f, newDir*speed * _timer);

    }

    void SetNewDir(int iterations)
    {

        if (iterations >= 10)
        {
            print("toom many iterations");
            newDir = Vector3.zero;
            return;
        }

        Vector3 shiftDir = Vector3.forward * Random.Range(5, 10);
        shiftDir = Quaternion.Euler(0, Random.Range(0, 360), 0) * shiftDir;

        newDir = ((player.transform.position + shiftDir)- transform.position).normalized;


        RaycastHit hit;
        Physics.Raycast(transform.position + Vector3.down * 0.95f, newDir, out hit, speed * _timer, ~LayerMask.NameToLayer("lava"), QueryTriggerInteraction.Collide);
        if (Physics.Raycast(transform.position+Vector3.down*0.9f, newDir, speed * _timer, ~0, QueryTriggerInteraction.Ignore) || hit.transform!= null && hit.transform.gameObject.tag == "Lava" )
        {
            if (iterations == 9)
            {
                print(hit.transform.gameObject.name);
            }
            SetNewDir(iterations + 1);
        }
    }
}
