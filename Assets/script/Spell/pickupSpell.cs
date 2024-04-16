using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.Events;

public class pickupSpell : MonoBehaviour
{

    bool canPickUp = false;
    GameObject player;
    GameObject gameController;
    public int spellNb;


    public UnityEvent unityEvent;

    public AudioClip audioClip;

    // Start is called before the first frame update
    void Start()
    {
        player = GameObject.Find("Player");
        gameController = GameObject.Find("GameController");
        if (spellNb <= gameController.GetComponent<gameController>().spellLimit)
        {
            Destroy(gameObject);
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Aura")
        {
            player.GetComponent<CastSpellNew>().limit++;
            gameController.GetComponent<gameController>().spellLimit = player.GetComponent<CastSpellNew>().limit;
            unityEvent.Invoke();
            player.transform.Find("AudioSource").GetComponent<AudioSource>().PlayOneShot(audioClip);
            Destroy(gameObject);
        }
    }
}
