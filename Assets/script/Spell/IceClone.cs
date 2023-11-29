using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IceClone : MonoBehaviour
{

    [SerializeField] GameObject iceExplosion, iceLine;
    [SerializeField] float timer, cooldown;
    bool iceCloneAlt;
    GameObject player;


    // Start is called before the first frame update
    void Start()
    {
        CastSpellNew.instance.cooldownIceClone = cooldown;

        player = GameObject.Find("Player").gameObject;
        iceCloneAlt = player.GetComponent<CastSpellNew>().iceCloneAlt;
    }

    // Update is called once per frame
    void Update()
    {
        timer -= Time.deltaTime;

        if (timer <= 0 && !iceCloneAlt) 
        {
            GameObject i = Instantiate(iceExplosion);
            i.transform.position = transform.position;
            Destroy(gameObject);
        }
        else if (timer <= 0 && iceCloneAlt)
        {
            Debug.Log("alt");
            GameObject j = Instantiate(iceLine);
            j.transform.position = transform.position;
            j.transform.rotation = transform.rotation;
            Destroy(gameObject);
        }
    }
}
