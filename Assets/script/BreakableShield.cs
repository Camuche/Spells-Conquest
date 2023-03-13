using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BreakableShield : MonoBehaviour
{
    [HideInInspector]public GameObject parent;
    [SerializeField]float life;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        transform.position = parent.transform.position;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.GetComponent<Wave>() != null)
        {
            life--;

            if (life <= 0){
                parent.GetComponent<ShieldedEnemy>().damageZone.SetActive(true);
                Destroy(gameObject);
            }
        }
    }
}
