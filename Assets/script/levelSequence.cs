using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class levelSequence : MonoBehaviour
{

    GameObject playerCam;
    [SerializeField] GameObject sequenceCam;
    Animation sequenceAnim;
    bool triggered = false;
    GameObject player;

    // Start is called before the first frame update
    void Start()
    {
        playerCam = Camera.main.gameObject;
        sequenceAnim = sequenceCam.GetComponent<Animation>();
    }

    // Update is called once per frame
    void Update()
    {
        if(!sequenceAnim.isPlaying && triggered)
        {
            playerCam.SetActive(true);
            sequenceCam.SetActive(false);
            //player.GetComponent<PlayerController>().setCanMove(true);
            Destroy(gameObject);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.name == "Player")
        {
            player = other.gameObject;
            playerCam.SetActive(false);
            sequenceCam.SetActive(true);
            sequenceAnim.Play();
            triggered = true;
            //player.GetComponent<PlayerController>().setCanMove(false);
        }
    }
}
