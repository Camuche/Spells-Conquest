using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class telekinesisClone : MonoBehaviour
{
    GameObject player;
    public float timer;
    [SerializeField] private float force;
    bool TelekinesisAlt;
    [SerializeField] float cooldown;
    [SerializeField] float attractSpeed;

    // Start is called before the first frame update
    void Start()
    {
        player = GameObject.Find("Player").gameObject;
        TelekinesisAlt = player.GetComponent<CastSpellNew>().TelekinesisAlt;
        player.GetComponent<CastSpellNew>().cooldownTelekinesisClone = cooldown;
    }

    // Update is called once per frame
    void Update()
    {
        timer -= Time.deltaTime;

        if (timer < 0)
        {
            player.GetComponent<PlayerController>().isAttracted = false;
            transform.position = new Vector3(100000, -100000, 100000);
            Destroy(gameObject, 0.1f);
        }

        attract(force);

        
    }


    [SerializeField] private bool attractProjectiles;
    private void attract(float force)
    {

        if(!TelekinesisAlt)
        {
            GameObject[] gos = FindObjectsOfType(typeof(GameObject)) as GameObject[]; //will return an array of all GameObjects in the scene
            foreach (GameObject go in gos)
            {
                if (go.layer == LayerMask.NameToLayer("enemi") || (go.layer == LayerMask.NameToLayer("enemiBullet" ) && attractProjectiles))
                {
                    Vector3 dir = (transform.position - go.transform.position).normalized;

                    CharacterController exists;
                    go.TryGetComponent<CharacterController>(out exists);

                    Vector3 movement = dir * force * Time.deltaTime * (go.layer == LayerMask.NameToLayer("enemiBullet") ? 5 : 1);

                    if (go.name.Contains("Shooting"))
                    {
                        movement *= 15f;
                    }

                    if (go.name.Contains("Turret"))
                    {
                        movement /= 3f;
                    }

                    if (exists != null && go.GetComponent<CharacterController>().enabled && go.GetComponent<IgnoreTeleClone>()==null)
                    {
                        go.GetComponent<CharacterController>().Move(movement);
                    }
                    else if(go.GetComponent<IgnoreTeleClone>() == null)
                    {
                        go.transform.position += movement;
                    }
                }
            }
        }
        //ATTRACT PLAYER
        else if(transform.position != player.transform.position && gameObject != null && player.GetComponent<PlayerController>().isAttracted == true)
        {
            player.GetComponent<PlayerController>().movedir = (transform.position - player.transform.position) * attractSpeed;
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            player.GetComponent<PlayerController>().isAttracted = false;
        }
    }
}
