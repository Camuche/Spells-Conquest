using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pot : MonoBehaviour
{
    [SerializeField] private GameObject money;
    [SerializeField] private int potMoneyNumber;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void OnTriggerEnter(Collider other)
    {
        if(other.tag == "Fireball")
        {
            for (int i=0; i<potMoneyNumber; i++)
            {
                //Debug.Log("1 Piece");
                Instantiate(money, transform.position +new Vector3(Random.Range(-1f,1f),0,Random.Range(-1f,1f)), transform.rotation * Quaternion.Euler(0,Random.Range(-180f,180f),0));
            }
            Destroy(gameObject);
            other.transform.position = new Vector3(666, -666, 666);
            Destroy(other.gameObject, 0.1f);
        }
    }
}
