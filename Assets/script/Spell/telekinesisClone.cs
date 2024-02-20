using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class telekinesisClone : MonoBehaviour
{
    GameObject player;
    public float timer;
    [SerializeField] private float force;
    bool TelekinesisAlt;
    [SerializeField] float cooldown;
    [SerializeField] float attractSpeed, enemyAttarctForce, enemyAttarctDist;
    [SerializeField] float playerStopDistance = 1.5f;


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
            //ResetNavMesh();
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
            Transform[] gos = EnemyManager.instance.transform.GetComponentsInChildren<Transform>() as Transform[]; //Array of enemies
            foreach (Transform gotr in gos)
            {
                GameObject go = gotr.gameObject;
                
                if (((go.layer == LayerMask.NameToLayer("enemi") || (go.layer == LayerMask.NameToLayer("enemiBullet" ) && attractProjectiles)) && Vector3.Distance(go.transform.position, transform.position) <= enemyAttarctDist) && go.name != "WeakPoint")
                {
                    go.GetComponent<NavMeshAgent>().enabled = false;
                    Rigidbody rb = go.GetComponent<Rigidbody>();
                    //rb.isKinematic = false;
                    //rb.useGravity = true;
					EnemyFollower ef = go.GetComponent<EnemyFollower>();
					//aorb.isKinematic = false;
					ef.useGravity = false;

                    Vector3 dir = (transform.position - go.transform.position).normalized;

                    CharacterController exists;
                    go.TryGetComponent<CharacterController>(out exists);

                    Vector3 movement = dir * force * Time.deltaTime * (go.layer == LayerMask.NameToLayer("enemiBullet") ? 5 : 1);

                    if (go.name.Contains("Laser") || go.name.Contains("Turret"))
                    {
                        movement *= 0;
                    }

                    

                    if (exists != null && go.GetComponent<CharacterController>().enabled && go.GetComponent<IgnoreTeleClone>()==null)
                    {
                        go.GetComponent<CharacterController>().Move(movement);
                    }
                    else if(go.GetComponent<IgnoreTeleClone>() == null)
                    {
                        rb.velocity= new Vector3 (movement.x * enemyAttarctForce, rb.velocity.y, movement.z * enemyAttarctForce);
                    }
                }
            }

            Transform[] aogos = AttractedObjectManager.instance.transform.GetComponentsInChildren<Transform>() as Transform[]; //Array of Movable Objects
            foreach (Transform aogotr in aogos)
            {
                GameObject aogo = aogotr.gameObject;
                
                if (Vector3.Distance(aogo.transform.position, transform.position) <= enemyAttarctDist)
                {
                    if (aogo != AttractedObjectManager.instance.gameObject)
                    {
                        CharacterController exists;
                        aogo.TryGetComponent<CharacterController>(out exists);

                        
                            AttractedObject aorb = aogo.GetComponent<AttractedObject>();
                            //aorb.isKinematic = false;
                            aorb.useGravity = false;
                        
                    

                        Vector3 dir = (transform.position - exists.transform.position).normalized;

                        Vector3 movement = dir * force * Time.deltaTime ;

                        if(exists != null)
                        {
                            exists.Move(new Vector3(movement.x * enemyAttarctForce * Time.deltaTime, movement.y * enemyAttarctForce * Time.deltaTime, movement.z * enemyAttarctForce * Time.deltaTime));
                        }
                    }
                    
                }
            }
        }
        //ATTRACT PLAYER
        else if(transform.position != player.transform.position && gameObject != null && player.GetComponent<PlayerController>().isAttracted == true)
        {
            player.GetComponent<PlayerController>().movedir = (transform.position - player.transform.position) * attractSpeed;

            //Ajout Bruno/Clement
            if((transform.position - player.transform.position).magnitude < playerStopDistance)
            {
                player.GetComponent<PlayerController>().isAttracted = false;
            }
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            player.GetComponent<PlayerController>().isAttracted = false;
        }
    }

    void ResetTargets()
    {
        //Debug.Log("1");
        Transform[] gos = EnemyManager.instance.transform.GetComponentsInChildren<Transform>() as Transform[]; //will return an array of all GameObjects in the scene
            foreach (Transform gotr in gos)
            {
                GameObject go = gotr.gameObject;

                NavMeshAgent refAgent = go.GetComponent<NavMeshAgent>();
                
                

                if (refAgent)
                {
					EnemyFollower ef = go.GetComponent<EnemyFollower>();
					//aorb.isKinematic = false;
					ef.useGravity = true;
					
                    //Rigidbody rb = go.GetComponent<Rigidbody>();
                    //rb.isKinematic = true;
                    //rb.useGravity = false;
                    //refAgent.enabled = true;
                    //Debug.Log("2");
                }

            }

        Transform[] aogos = AttractedObjectManager.instance.transform.GetComponentsInChildren<Transform>() as Transform[]; //Array of Movable Objects
        foreach (Transform aogotr in aogos)
        {
            GameObject aogo = aogotr.gameObject;

            if (aogo != AttractedObjectManager.instance.gameObject)
            {

                AttractedObject ao = aogo.GetComponent<AttractedObject>();
                //aorb.isKinematic = false;
                ao.useGravity = true;
            }
        }
    }

    void OnDestroy()
    {
        ResetTargets();
    }
}
