using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SmokeProtection : MonoBehaviour
{

    GameObject player;
    [SerializeField] float protectDistance;

    // Start is called before the first frame update
    void Start()
    {
        player = GameObject.Find("Player");
    }

    // Update is called once per frame
    void Update()
    {

        GameObject[] protectors = GameObject.FindGameObjectsWithTag("ShaderEffect");
        GameObject closestObject;

        float oldDistance = Mathf.Infinity;

        foreach (GameObject p in protectors)
        {
            float dist = Vector3.Distance(gameObject.transform.position, p.transform.position);
            if (dist < oldDistance)
            {
                closestObject = p;
                oldDistance = dist;
            }
        }

        if (oldDistance< protectDistance)
        {
            GameObject.Find("SmokePrefab").GetComponent<DamageZone>().damage = 0;
        }
        else
        {
            GameObject.Find("SmokePrefab").GetComponent<DamageZone>().damage = 100;
        }
    }

}
