using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Money : MonoBehaviour
{
    [SerializeField] float speed, speedTowardPlayer, timeFloating;
    Vector3 targetPosition;
    float randomRange;
    bool followPlayer = false;
    GameObject player;

    // Start is called before the first frame update
    void Start()
    {
        randomRange = Random.Range(0.5f, 2f);
        targetPosition = transform.position + Vector3.up * randomRange;
        player = GameObject.Find("Player");
    }

    // Update is called once per frame
    void Update()
    {
        if(!followPlayer)
        {
            transform.position = Vector3.MoveTowards(transform.position, targetPosition, 0.01f * speed * randomRange);
        }
        

        if (transform.position == targetPosition)
        {
            followPlayer = true;
        }

        if (followPlayer)
        {
            transform.position = Vector3.MoveTowards(transform.position, player.transform.position, speedTowardPlayer * Time.deltaTime);
        }
    }
}
