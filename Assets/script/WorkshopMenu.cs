using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class WorkshopMenu : MonoBehaviour
{
    GameObject refgameController;
    // Start is called before the first frame update
    void Start()
    {
        if(GameObject.Find("UI(Clone)")!=null)
            GameObject.Find("UI(Clone)").SetActive(Cursor.lockState != CursorLockMode.None);

        
        
        
    }

    // Update is called once per frame
    void Update()
    {

        refgameController = GameObject.Find("GameController");
        

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
            refgameController.GetComponent<gameController>().Play();


        }
        SceneManager.LoadScene("Menu");
        Cursor.lockState = CursorLockMode.None;
    }
}
