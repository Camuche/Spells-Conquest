using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemiFireShield : MonoBehaviour
{

    [HideInInspector] public GameObject parent;
    [SerializeField] int life = 1;
    [SerializeField] Collider ignoreCol;

    float parentLife;

    // Start is called before the first frame update
    void Start()
    {
        parentLife = transform.parent.GetComponent<EnemyLife>().life;
    }

    // Update is called once per frame
    void Update()
    {

        if (GameObject.Find("TelekinesisClone(Clone)"))
        {
            Physics.IgnoreCollision(GetComponent<Collider>(), GameObject.Find("TelekinesisClone(Clone)").GetComponent<Collider>());
        }

        if (GameObject.FindGameObjectsWithTag("Fireball").Length > 0)
        {
            Physics.IgnoreCollision(GetComponent<Collider>(), GameObject.FindGameObjectsWithTag("Fireball")[0].GetComponent<Collider>());
        }

        //transform.parent.gameObject.transform.GetComponent<EnemyLife>().IgnoreCol = ignoreCol;

        transform.position = parent.transform.position;

        transform.parent.GetComponent<EnemyLife>().life = parentLife;
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
        transform.parent.gameObject.transform.GetComponent<EnemyLife>().IgnoreCol = transform.parent.Find("DamageZone").GetComponent<SphereCollider>();
    }
}
