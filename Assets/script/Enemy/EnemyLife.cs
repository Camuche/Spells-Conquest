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


        if (other.tag == "Fireball" || other.tag == "Iceball")
        {
            life -= 10;
            Destroy(other.gameObject);
        }

        if (life <= 0)
        {
            Destroy(gameObject);
        }
    }


}
