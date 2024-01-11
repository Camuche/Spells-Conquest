using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.EventSystems;

public class MenuScript : MonoBehaviour
{
    



    public void Workshop_Environment()
    {
        SceneManager.LoadScene("Workshop_Environment");
    }

    public void Workshop_Arena()
    {
        SceneManager.LoadScene("Workshop_Arena"); 
    }

    public void Level()
    {
        SceneManager.LoadScene("Level 1");
    }

    public void Menu()
    {
        SceneManager.LoadScene("Menu");
    }

    public void ExitGame()
    {
        Application.Quit();
    }

    public void ResumeGame()
    {
        GameObject.Find("GameController").GetComponent<gameController>().isPaused = false;
        GameObject.Find("GameController").GetComponent<gameController>().Play();
    }

    /*public void SelectSpellLeft(int value)
    {
        CastSpellNew.instance.SelectSpellLeft(value);
        Debug.Log("Click");
    }

    public void SelectSpellRight(int value)
    {
        CastSpellNew.instance.SelectSpellRight(value);
    }*/

    public void SelectSpell(int value)
    {
        if(CastSpellNew.instance.hand == 1)
        {
            CastSpellNew.instance.SelectSpellRight(value);
        }       
        
        if(CastSpellNew.instance.hand == -1)
        {
            CastSpellNew.instance.SelectSpellLeft(value);
        }    
    }

    public void HighlightTarget(GameObject target)
    {
        Debug.Log("plop");
        UIupdate.instance.HighlightTarget(target);
    }
    public void UnHighlightTarget(GameObject target)
    {
        UIupdate.instance.UnHighlightTarget(target);
    }


    // SHOP SCRIPT
}
