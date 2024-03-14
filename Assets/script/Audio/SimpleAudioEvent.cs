using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName ="Audio Events/Simple")]
public class SimpleAudioEvent : AudioEvent
{

    public AudioClip[] clips;

    public Vector2 volume;

    public Vector2 pitch;

	public override void Play(AudioSource source)
	{
		//throw new System.NotImplementedException();

		if (clips.Length == 0)
		{
			return;
		}

		source.clip = clips[Random.Range(0, clips.Length)];
		source.volume = Random.Range(volume.x, volume.y);
		source.pitch = Random.Range(pitch.x, pitch.y);
		source.Play();
	}
}
