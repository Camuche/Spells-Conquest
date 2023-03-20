using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class gameController : MonoBehaviour
{

    [SerializeField] Material matLave;

    GameObject player;

    public Vector3 CheckPoint = Vector3.zero;
    public bool checkpointed = false;
    public int spellLimit;

    List<string> spellsToDestroy = new List<string>();
    [HideInInspector] public List<string> spellsToDestroyNext = new List<string>();





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
        destroySpells();

        
        GetSliderValue();

        if (Input.GetKeyDown("p"))
        {
            if (isPaused)
            {
                Play();
            }
            else
            {
                Pause();
            }
        }
        print(isPaused);

    }

    public void setSpellsToDestroy()
    {
        spellsToDestroy = spellsToDestroyNext;
    }

    void destroySpells()
    {

        List<GameObject> spellsToCheck = new List<GameObject>();

        GameObject[] allObjects = FindObjectsOfType<GameObject>();

        foreach (GameObject go in allObjects)
        {
            if (go.GetComponent<pickupSpell>() != null)
            {
                spellsToCheck.Add(go);
            }
        }


        foreach (string spell in spellsToDestroy)
        {
            foreach(GameObject go in spellsToCheck)
            {
                if (go.transform.position.x.ToString() + go.transform.position.z.ToString() == spell)
                {
                    Destroy(go);
                }
            }
        }
    }

    public float newSensitivity;
    public void GetSliderValue()
    {
        newSensitivity = GameObject.Find("Sensitivity").GetComponent<Slider>().value;
        Debug.Log(newSensitivity);
        player.GetComponent<PlayerController>().mouseSensitivity = newSensitivity;
    }

    public bool isPaused = false;
    void Pause()
    {
        Time.timeScale = 0;
        Cursor.lockState = CursorLockMode.None;
        isPaused = true;
    }
    void Play()
    {
        Time.timeScale = 1;
        Cursor.lockState = CursorLockMode.Locked;
        isPaused = false;
    }


}
