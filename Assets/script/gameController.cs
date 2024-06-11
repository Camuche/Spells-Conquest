using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using UnityEngine.InputSystem;

public class gameController : MonoBehaviour
{

    [SerializeField] Material matLave;

    GameObject player;

    public Vector3 CheckPoint = Vector3.zero;
    public bool checkpointed = false;
    public int spellLimit;

    List<string> spellsToDestroy = new List<string>();
    [HideInInspector] public List<string> spellsToDestroyNext = new List<string>();

    [SerializeField] private InputActionReference escape, menuEscape, aura;



    private void OnLevelWasLoaded(int level)
    {

        
        

        matLave.SetVector("_SpherePosition", new Vector4(0, 9999999999999, 0, 0));

        //Debug.Log("spellLimit : " + spellLimit);
        player = GameObject.Find("Player");
        //PlayerController.instance.canMove = true;
        Invoke("DelayedInitialisation", Time.deltaTime);
        if (checkpointed)
        {
            //Debug.Log("reloaded");
            player.transform.position = CheckPoint;
            //player.GetComponent<CastSpellNew>().limit = spellLimit;
        }
    }

    void DelayedInitialisation()
    {
        if(spellLimit == -1)
        {
            return;
        }
        player.GetComponent<CastSpellNew>().limit = spellLimit;
    }

    

    // Start is called before the first frame update
    void Start()
    {

        player = GameObject.Find("Player");
        //spellLimit = player.GetComponent<CastSpellNew>().limit;
        CheckPoint = Vector3.zero;
        checkpointed = false;

        Invoke("StartContent",Time.deltaTime);

        


    }

    void StartContent()
    {
        if (SceneManager.GetActiveScene().name != "Menu")
        {
            Play();
        }
        if(PlayerController.tutoDone)
        {
            //GetComponent<UIupdate>().displayInput.SetActive(false);
            DisplayInput.instance.HideInput();
        }
    }

    void OnEnable()
    {
        escape.action.performed += PerformEscape;
        menuEscape.action.performed += PerformEscape;
    }

    void OnDisable()
    {
        escape.action.performed -= PerformEscape;
        menuEscape.action.performed -= PerformEscape;
    }

    private void PerformEscape(InputAction.CallbackContext obj)
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

    [HideInInspector] public bool xWasPressed;


    
    // Update is called once per frame
    void Update()
    {
        if(!xWasPressed && aura.action.WasPressedThisFrame() && player.GetComponent<PlayerInput>().enabled == true && !PlayerController.tutoDone)
        {
            xWasPressed = true;
            PlayerController.instance.canMove = true;
            PlayerController.tutoDone = true;
            //GetComponent<UIupdate>().displayInput.SetActive(false);
            DisplayInput.instance.HideInput();
        }

        //Debug.Log(spellLimit);

        if (SceneManager.GetActiveScene().name == "Menu")
        {
            Destroy(GameObject.Find("PersistentObject"));
            Destroy(GameObject.Find("DontDestroy"));

        }

        //destroySpells();

        if (GameObject.Find("Sensitivity") != null)
        {
            GetSliderValue();

        }
        

        /*if (escape.action.IsPressed)
        {
            if (isPaused)
            {
                Play();
            }
            else
            {
                Pause();
            }
        }*/

        //print(GameObject.Find("Sensitivity"));
    }

    public void setSpellsToDestroy()
    {
        spellsToDestroy = spellsToDestroyNext;
    }

    /*void destroySpells()
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
    }*/

    public float newSensitivity;
    
    public void GetSliderValue()
    {
        newSensitivity = GameObject.Find("Sensitivity").GetComponent<Slider>().value;
        if (player!=null) player.GetComponent<PlayerController>().mouseSensitivity = newSensitivity;
    }

    public bool isPaused = false;
    public void Pause()
    {
        Time.timeScale = 0;
        Cursor.lockState = CursorLockMode.None;
        isPaused = true;
        PlayerController.instance.refPlayerInput.SwitchCurrentActionMap("MenuInput");
    }
    public void Play()
    {
        Time.timeScale = 1;
        Cursor.lockState = CursorLockMode.Locked;
        isPaused = false;
        PlayerController.instance.refPlayerInput.SwitchCurrentActionMap("PlayerInput");
    }

    

    

}
