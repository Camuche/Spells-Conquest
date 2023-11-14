using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyLife : MonoBehaviour
{

    public float life;
    public bool DisplayLife;
    GameObject healthBar;

    private float maxLife;

    public Collider IgnoreCol;

    [SerializeField] private GameObject money; 
    [SerializeField] private int dropMoneyNumber;

    



    // Start is called before the first frame update
    void Start()
    {
        healthBar = transform.Find("HealthBar").gameObject;

        if (DisplayLife)
        {
            healthBar.GetComponent<CanvasGroup>().alpha = 1;
        }
        else
        {
            healthBar.GetComponent<CanvasGroup>().alpha = 0;
        }


        maxLife = life;




    }

    // Update is called once per frame
    void Update()
    {
        drawHealth();


        if (IgnoreCol != null)
        {
            if (GameObject.Find("PrefabFireball(Clone)"))
            {
                Physics.IgnoreCollision(IgnoreCol, GameObject.Find("PrefabFireball(Clone)").GetComponent<SphereCollider>());
            }
        }

    }


    private void drawHealth()
    {
        healthBar.transform.Find("ImageGreen").GetComponent<RectTransform>().localScale = new Vector3((float)(life/maxLife),1,1);
    }

    private void OnTriggerEnter(Collider other)
    {


        if (other.tag == "Fireball")
        {
            life -= Fireball.instance.fireballDamage;
            Destroy(other.gameObject);
        }
        if (other.tag == "Iceball")
        {
            life -= IceBall.instance.iceballDamage;
            Destroy(other.gameObject);
        }

        if (life <= 0)
        {
            for (int i=0; i<dropMoneyNumber; i++)
            {
                //Debug.Log("1 Piece");
                Instantiate(money, transform.position +new Vector3(Random.Range(-1f,1f),0,Random.Range(-1f,1f)), transform.rotation * Quaternion.Euler(0,Random.Range(-180f,180f),0));
            }
            Destroy(gameObject);
        }
    }


}
