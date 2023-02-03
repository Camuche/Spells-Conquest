using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyLife : MonoBehaviour
{

    public float life;
    public bool DisplayLife;
    GameObject healthBar;

    private float maxLife;

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
    }


    private void drawHealth()
    {
        healthBar.transform.Find("ImageGreen").GetComponent<RectTransform>().localScale = new Vector3((float)(life/maxLife),1,1);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.transform.name.Contains("Fireball"))
        {
            life -= 10;
        }

        if (life <= 0)
        {
            Destroy(gameObject);
        }
    }


}
