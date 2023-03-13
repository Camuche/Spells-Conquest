using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemiFireShield : MonoBehaviour
{

    [HideInInspector] public GameObject parent;
    [SerializeField] int life = 1;

    // Start is called before the first frame update
    void Start()
    {
        print("ENEMYFIRESHIELD");
    }

    // Update is called once per frame
    void Update()
    {

        transform.position = parent.transform.position;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.name.Contains("IceBall"))
        {
            life--;
        }

        if (life <= 0)
        {
            parent.GetComponent<ShieldedEnemy>().damageZone.SetActive(true);
            Destroy(gameObject);
            
        }
    }

    private void OnDestroy()
    {
        print("HAHA");
    }
}
