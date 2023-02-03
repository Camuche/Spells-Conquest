using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class telekinesisClone : MonoBehaviour
{
    public float timer;
    [SerializeField] private float force;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        timer -= Time.deltaTime;

        if (timer < 0)
        {
            Destroy(gameObject);
        }

        attract(force);

        
    }


    [SerializeField] private bool attracktProjectiles;
    private void attract(float force)
    {


        GameObject[] gos = FindObjectsOfType(typeof(GameObject)) as GameObject[]; //will return an array of all GameObjects in the scene
        foreach (GameObject go in gos)
        {
            if (go.layer == LayerMask.NameToLayer("enemi") || (go.layer == LayerMask.NameToLayer("enemiBullet" ) && attracktProjectiles))
            {
                Vector3 dir = (transform.position - go.transform.position).normalized;

                CharacterController exists;
                go.TryGetComponent<CharacterController>(out exists);

                Vector3 movement = dir * force * Time.deltaTime * (go.layer == LayerMask.NameToLayer("enemiBullet") ? 5 : 1);

                if (exists != null)
                {
                    go.GetComponent<CharacterController>().Move(movement);
                }
                else
                {
                    go.transform.position += movement;
                }
            }
        }
    }
}
