using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimatorBasicEnemy : MonoBehaviour
{
    [SerializeField] private EnemyFollower enemyFollower;
    private Animator animator;
    bool currentlyAttacking;
    PlayerController playerController;

    public AudioSource refAudioSource;
    public AudioEvent refAudioEvent;


    // Start is called before the first frame update
    void Start()
    {
        animator = gameObject.GetComponent<Animator>();
        playerController = GameObject.Find("Player").GetComponent<PlayerController>();
    }

    // Update is called once per frame
    void Update()
    {
        if (enemyFollower.isDetected && !animator.GetBool("isChasing") && !enemyFollower.isStun && !playerController.isDead)
        {
            animator.SetBool("isChasing", true);
        }
        else if ((!enemyFollower.isDetected || enemyFollower.isStun || playerController.isDead) && animator.GetBool("isChasing"))
        {
            animator.SetBool("isChasing", false);
        }
    }

    public void AttackAnimation()
    {
        animator.SetTrigger("attack");
    }

    public void PlayStepSound()
    {
        refAudioEvent.Play(refAudioSource);
        Debug.Log("Sound");
        //refAudioSource.PlayOneShot();
    }
}
