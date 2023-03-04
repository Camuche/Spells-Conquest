using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class kamikaze : MonoBehaviour
{


    [SerializeField] float explosionDistance;
    [SerializeField] float explosionRange;

    [SerializeField] GameObject explosionObject;
    GameObject player;


    // Start is called before the first frame update
    void Start()
    {
        player = GameObject.Find("Player");
    }

    // Update is called once per frame
    void Update()
    {
        if (Vector3.Distance(transform.position, player.transform.position) < explosionDistance)
        {
            Destroy(gameObject);
        }
    }


    bool gameIsShuttingDown=false;
    void OnApplicationQuit()
    {
        this.gameIsShuttingDown = true;
    }

    private void OnDestroy()
    {

        if (!this.gameIsShuttingDown)
            explode();
    }

    void explode()
    {
        GameObject e = Instantiate(explosionObject);
        e.GetComponent<explosion>().scale = explosionRange;
        e.transform.position = transform.position;
        
    }
}
