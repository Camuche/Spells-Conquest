using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.EventSystems;

public class WorkshopMenu : MonoBehaviour
{
    GameObject refgameController;
    // Start is called before the first frame update

    [SerializeField] GameObject b_menu;

    [SerializeField] GameObject b_level, b_environement, b_arena;

    bool paused = false;


    void Start()
    {
        if(GameObject.Find("UI(Clone)")!=null)
            GameObject.Find("UI(Clone)").SetActive(Cursor.lockState != CursorLockMode.None);

        if (b_menu != null)
            EventSystem.current.SetSelectedGameObject(b_menu);
        else
        {
            EventSystem.current.SetSelectedGameObject(b_level);

        }


    }

    // Update is called once per frame
    void Update()
    {
        refgameController = GameObject.Find("GameController");

        if (refgameController != null && refgameController.GetComponent<gameController>().isPaused)
        {
            Cursor.lockState = CursorLockMode.None;
        }

            if (refgameController != null && refgameController.GetComponent<gameController>().isPaused && !paused)
        {
            Cursor.lockState = CursorLockMode.None;

            EventSystem.current.SetSelectedGameObject(null);
            if(b_menu!=null)
                EventSystem.current.SetSelectedGameObject(b_menu);
            else
            {
                EventSystem.current.SetSelectedGameObject(b_level);

            }

            paused = true;


        }

        if (refgameController != null && !refgameController.GetComponent<gameController>().isPaused && paused)
        {
            //paused = false;
        }

        print(Cursor.lockState);


    }

    public void Workshop_Environment()
    {
        if(refgameController != null)
        {
            refgameController.GetComponent<gameController>().Play();

        }
        SceneManager.LoadScene("Workshop_Environment");

    }

    public void Workshop_Arena()
    {
        if (refgameController != null)
        {  
            refgameController.GetComponent<gameController>().Play();


        }
        SceneManager.LoadScene("Workshop_Arena"); 
    }

    public void Level()
    {
        if (refgameController != null)
        {     
            refgameController.GetComponent<gameController>().Play();


        }
        SceneManager.LoadScene("Level");
    }

    public void Menu()
    {
        if(refgameController != null)
        {   
            //refgameController.GetComponent<gameController>().Play();


        }
        SceneManager.LoadScene("Menu");
        Cursor.lockState = CursorLockMode.None;
    }
}
