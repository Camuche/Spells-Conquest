using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class gameController : MonoBehaviour
{

    [SerializeField] Material matLave;

    GameObject player;

    public Vector3 CheckPoint = Vector3.zero;
    public bool checkpointed = false;
    public int spellLimit;

    private void OnLevelWasLoaded(int level)
    {

        matLave.SetVector("_SpherePosition", new Vector4(0, 9999999999999, 0, 0));


        player = GameObject.Find("Player");
        if (checkpointed)
        {
            player.transform.position = CheckPoint;
            player.GetComponent<CastSpell>().limit = spellLimit;
        }
    }

    // Start is called before the first frame update
    void Start()
    {

        player = GameObject.Find("Player");
        //spellLimit = player.GetComponent<CastSpell>().limit;
        CheckPoint = Vector3.zero;
        checkpointed = false;


    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
