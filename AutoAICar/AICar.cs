using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AICar : MonoBehaviour
{
    public RoadTileManager RoadManager;
    Rigidbody2D CarRigidbody;

    public float Speed = 10f;
    public float OffsetFromMiddle = 1.5f;

    public RoadLane Lane;
    public enum RoadLane
    {
        LeftLane,
        RightLane
    }

    private RoadTile _actualTile;
    private Vector2 _targetPosition;
    private Vector2 _beforePosition;
    private Vector2 _nextForward;
    private Vector2 _beforeForward;
    private int _roadPointIndex;
    private int _maxRoadPointIndex;
    private float _lerpT;
    private bool _moving = false;

    Vector3 _velocity;
    private Vector3 _movementDirection;

    void Start()
    {
        CarRigidbody = GetComponent<Rigidbody2D>();
        CarRigidbody.bodyType = RigidbodyType2D.Kinematic;
    }

    void Update()
    {
        // Odszukaj drogę na jakiej jest samochód
        if (_actualTile == null)
        {
            if (Lane == RoadLane.RightLane)
                _actualTile = RoadManager.LookForTileAtPosition(transform.position.y + 1);
            else
                _actualTile = RoadManager.LookForTileAtPosition(transform.position.y - 1);
        }
        else
        {
            // Znajdz cel, jeżeli go nie ma
            if (_targetPosition == Vector2.zero)
            {
                FindNextPosition();
            }

            // Jezeli pojazd jest blisko celu i ma go wręcz przekroczyc, znajdz kolejny cel
            if(Vector3.Distance(transform.position, _targetPosition) < _velocity.magnitude)
            {
                // Następny punkt
                if (Lane == RoadLane.RightLane) 
                    _roadPointIndex += 1;
                else
                    _roadPointIndex -= 1;

                //Koniec Trasy
                if (_roadPointIndex >= _actualTile.Path.EvenlySpacedPoints.Count)
                {
                    _actualTile = RoadManager.LookForTileAtPosition(transform.position.y + 1);
                    _roadPointIndex = 0;
                }
                else if (_roadPointIndex < 0)
                {
                    _actualTile = RoadManager.LookForTileAtPosition(transform.position.y - 1);
                    _roadPointIndex = _actualTile.Path.EvenlySpacedPoints.Count - 1;
                }

                // Znajdz kolejny cel
                FindNextPosition();
            }
        
            // Fizyka pojazdu
            _movementDirection = (_targetPosition - (Vector2)transform.position).normalized;
            _velocity = _movementDirection * Speed * Time.deltaTime;

            // Update
            transform.position += (Vector3)_velocity;
            transform.rotation = Quaternion.LookRotation(Vector3.forward, _movementDirection);
        }

    }

    void FindNextPosition()
    {
        Vector2 offset = _actualTile.PointRightVector(_roadPointIndex) * OffsetFromMiddle;
        if (Lane == RoadLane.LeftLane)
            offset *= -1;

        _targetPosition = (Vector2)_actualTile.transform.position + _actualTile.Path.EvenlySpacedPoints[_roadPointIndex] + offset;
    }
}