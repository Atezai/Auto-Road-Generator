using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GroundFollow : MonoBehaviour {

    public Transform Car;
    Vector2 _localOffset;
	// Use this for initialization
	void Start () {
        _localOffset = transform.position - Car.position;
	}
	
	// Update is called once per frame
	void FixedUpdate () {
        transform.position = Car.position + (Vector3)_localOffset;
	}
}
